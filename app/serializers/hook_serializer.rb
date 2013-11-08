class HookSerializer < ApplicationSerializer
  attributes :id, :name, :events, :config, :state, :_links

  # def config
    # object.config? ? object.config : nil
  # end

  def _links
    {
      self: { href: api_hook_path(object) },
    }
  end
end
