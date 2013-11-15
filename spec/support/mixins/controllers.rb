require "active_support/concern"

module Support
  module Controllers
    extend ActiveSupport::Concern

    included do
      subject(:it) { controller }
      Rails.application.routes.default_url_options[:host] = "test.host"
      include ActionDispatch::Routing::UrlFor
      include Rails.application.routes.url_helpers
    end

    module ClassMethods

      def stub_account
        let(:account) { build_stubbed(:account) }
        let(:current_user) { build_stubbed(:user, account: account) }
        let(:current_service) { build_stubbed(:service, account: account) }
        let(:other_user) { build_stubbed(:user) }
        let(:other_service) { build_stubbed(:user) }
      end

      def stub_model(stubs={})
        let(:model) { self.class.model }
        let(:model_name) { self.class.model_name }
        let(:resource) { mock_model(model_name, stubs) }
        let(:new_resource) { mock_model(model_name, stubs) }#.as_new_record }
        let(:resource_name) { self.class.resource_name }
        let(:collection) { [ resource ] }
        let(:collection_name) { self.class.collection_name }
        let(resource_name) { resource }
        let(collection_name) { collection }

        before(:each) do
          allow(model).to receive(:all).and_return(collection)
          allow(model).to receive(:find_by).with(uuid: resource.to_param).and_return(resource)
          allow(model).to receive(:new).and_return(new_resource.as_new_record)
          allow(resource).to receive(:save).and_return(true)
          allow(new_resource).to receive(:save).and_return(true)
        end
      end

      shared_examples "index_success" do
        stub_model

        it "success" do
          get :index

          expect(controller).to render_template(:index)
          expect(controller).to respond_with(:ok)
          expect(controller).to assign_to(collection_name).with(collection)
          expect(model).to have_received(:all)
        end
      end

      shared_examples "show_success" do |params={}|
        stub_model

        it "success" do
          allow(model).to receive(:find_by).with(uuid: resource.to_param).and_return(resource)

          get :show, { id: resource.to_param }.merge(params)

          expect(controller).to render_template(:show)
          expect(controller).to respond_with(:ok)
          expect(controller).to assign_to(resource_name).with(resource)
          expect(model).to have_received(:find_by).with(uuid: resource.to_param)
        end
      end

      shared_examples "new_success" do |params={}|
        stub_model

        it "success" do
          get :new, { }.merge(params)

          expect(controller).to render_template(:new)
          expect(controller).to respond_with(:ok)
          expect(controller).to assign_to(resource_name).with(new_resource)
          expect(model).to have_received(:new)
        end
      end

      shared_examples "create_success" do |params={}|
        stub_model

        it "success" do
          # allow(new_resource).to receive(:save).and_return(true)
          puts resource_name
          post :create, { resource_name => { :foo => "bar" } }.merge(params)

          expect(new_resource).to have_received(:save)
          expect(controller).to assign_to(resource_name).with_kind_of model
          expect(controller).to respond_with(:found)
          expect(controller).to set_the_flash[:notice].to(/successfully created/)
        end
      end

      shared_examples "create_failure" do |params={}|
        stub_model

        it "failure" do
          allow(model).to receive(:new).and_return(new_resource)
          allow(new_resource).to receive(:save).and_return(false)
          allow(new_resource).to receive(:errors).and_return({ :foo => "bar" })

          post :create, { resource_name => { :foo => "bar" } }.merge(params)

          expect(controller).to assign_to(resource_name).with(new_resource)
          expect(assigns(resource_name)).to be_a_new(model)
          expect(new_resource).to have_received(:save)
          expect(controller).to render_template(:new)
          expect(controller).to set_the_flash[:alert].to(/could not be created/)
        end
      end

      shared_examples "edit_success" do |params={}|
        stub_model

        it "success" do
          get :edit, { id: resource.to_param }.merge(params)

          expect(controller).to assign_to(resource_name).with(resource)
          expect(controller).to render_template(:edit)
          expect(model).to have_received(:find_by).with(uuid: resource.to_param)
        end
      end

      shared_examples "update_success" do |params={}|
        stub_model

        it "success" do
          allow(resource).to receive(:update).and_return(true)

          put :update, { id: resource.to_param, resource_name => { :f => :b } }.merge(params)

          expect(model).to have_received(:find_by).with(uuid: resource.to_param)
          expect(controller).to assign_to(resource_name).with(resource)
          expect(resource).to have_received(:update)
          expect(controller).to redirect_to resource
          expect(controller).to set_the_flash[:notice].to(/successfully updated/)
        end
      end

      shared_examples "update_failure" do |params={}|
        stub_model

        it "failure" do
          allow(resource).to receive(:update).and_return(false)
          allow(resource).to receive(:errors).and_return({ :foo => "bar" })

          put :update, { id: resource.to_param, resource_name => {} }.merge(params)

          expect(controller).to assign_to(resource_name).with(resource)
          expect(model).to have_received(:find_by).with(uuid: resource.to_param)
          expect(resource).to have_received(:update)
          expect(controller).to render_template(:edit)
          expect(controller).to set_the_flash[:alert].to(/could not be updated/)
        end
      end

      shared_examples "destroy_success" do |params={}|
        stub_model

        it "success" do
          allow(resource).to receive(:destroy).and_return(true)
          allow(resource).to receive(:errors).and_return({})

          delete :destroy, { id: resource.to_param }.merge(params)

          expect(model).to have_received(:find_by)
          expect(controller).to assign_to(resource_name).with(resource)
          expect(resource).to have_received(:destroy)
          expect(controller).to set_the_flash[:notice].to(/successfully deleted/)
        end
      end

      shared_examples "destroy_failure" do |params={}|
        stub_model destroy: false

        it "failure" do
          allow(resource).to receive(:destroy).and_return(false)
          allow(resource).to receive(:errors).and_return({ :foo => "bar" })

          delete :destroy, { id: resource.to_param }.merge(params)

          expect(model).to have_received(:find_by).with(uuid: resource.to_param)
          expect(controller).to assign_to(resource_name).with(resource)
          expect(resource).to have_received(:destroy)
          expect(controller).to redirect_to polymorphic_url(resource)
          expect(controller).to set_the_flash[:alert].to(/could not be deleted/)
        end
      end

      def model_name
        described_class.to_s.demodulize.sub(/Controller/, "").singularize
      end

      def model
        model_name.constantize
      end

      def resource_name
        model_name.to_s.underscore
      end

      def plural_resource_name
        resource_name.pluralize
      end

      def resource(stubs={})
        mock_model(model_name, stubs).as_null_object
      end

      def collection_name
        resource_name.pluralize
      end

      def collection(stubs={})
        [ resource(stubs) ]
      end

    end
  end
end

RSpec.configure do |config|
  config.include Support::Controllers, type: :controller
end
