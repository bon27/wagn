class CardSweeper < ActionController::Caching::Sweeper
  observe Card::Base

  def before_save(card)               
    expire_card(card)

    # FIXME: this will need review when we do the new defaults/templating system
    if card.updates.for?(:content)
      card.templatees.each {|c| expire_card(c) }     
      card.transcluders.each {|c| expire_card(c) }
    end
    
    if card.updates.for?(:name)
      card.dependents.each {|c| expire_card(c) }
      card.referencers.each {|c| expire_card(c) }
    end
  end
  
  private
  def expire_card(c)
    expire_fragment("card/view/#{c.id}")   
  end
  
end
