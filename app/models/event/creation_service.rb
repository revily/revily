class Event::CreationService
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def create
    unless Revily::Event.paused?
      Event.create(
        account: account,
        action: action,
        source: source,
        actor: actor,
        changeset: changeset
      )
    end
  end

  def account
    object.account
  end

  def action
    source.event_action
  end

  def source
    object
  end

  def actor
    Revily::Event.actor
  end

  def changeset
    { state: [ source.transition_from, source.transition_to ] }
  end

end