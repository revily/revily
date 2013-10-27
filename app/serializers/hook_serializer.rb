class HookSerializer < ApplicationSerializer
  attributes :id, :name, :events, :config, :state, :_links

  # def config
    # object.config? ? object.config : nil
  # end

  def _links
    {
      self: { href: hook_path(object) },
    }
  end
end
