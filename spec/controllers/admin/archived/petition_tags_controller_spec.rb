require 'rails_helper'

RSpec.describe Admin::Archived::PetitionTagsController, type: :controller, admin: true do
  let!(:petition) { FactoryBot.create(:archived_petition) }
  let!(:creator) { FactoryBot.create(:archived_signature, :validated, creator: true, petition: petition) }

  context "when not logged in" do
    describe "GET /admin/archived/petitions/:petition_id/tags" do
      it "redirects to the login page" do
        get :show, params: { petition_id: petition.id }
        expect(response).to redirect_to("https://moderate.demokra.si/admin/login")
      end
    end

    describe "PATCH /admin/archived/petitions/:petition_id/tags" do
      it "redirects to the login page" do
        patch :update, params: { petition_id: petition.id }
        expect(response).to redirect_to("https://moderate.demokra.si/admin/login")
      end
    end
  end

  context "when logged in as moderator user but need to reset password" do
    let(:user) { FactoryBot.create(:moderator_user, force_password_reset: true) }
    before { login_as(user) }

    describe "GET /admin/archived/petitions/:petition_id/tags" do
      it "redirects to the edit profile page" do
        get :show, params: { petition_id: petition.id }
        expect(response).to redirect_to("https://moderate.demokra.si/admin/profile/#{user.id}/edit")
      end
    end

    describe "PATCH /admin/archived/petitions/:petition_id/tags" do
      it "redirects to the edit profile page" do
        patch :update, params: { petition_id: petition.id }
        expect(response).to redirect_to("https://moderate.demokra.si/admin/profile/#{user.id}/edit")
      end
    end
  end

  context "when logged in as moderator user" do
    let(:user) { FactoryBot.create(:moderator_user) }
    before { login_as(user) }

    describe "GET /admin/archived/petitions/:petition_id/tags" do
      before { get :show, params: { petition_id: petition.id } }

      it "returns 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the :show template" do
        expect(response).to render_template("admin/archived/petitions/show")
      end
    end

    describe "PATCH /admin/archived/petitions/:petition_id/tags" do
      before { patch :update, params: { petition_id: petition.id, petition: params } }

      context "and the params are invalid" do
        let :params do
          { tags: ["999"] }
        end

        it "returns 200 OK" do
          expect(response).to have_http_status(:ok)
        end

        it "renders the :show template" do
          expect(response).to render_template("admin/archived/petitions/show")
        end
      end

      context "and the params are empty" do
        let :params do
          { tags: [""] }
        end

        it "redirects to the petition page" do
          expect(response).to redirect_to("https://moderate.demokra.si/admin/archived/petitions/#{petition.id}")
        end

        it "sets the flash notice message" do
          expect(flash[:notice]).to eq("Petition has been successfully updated")
        end
      end

      context "and the params are valid" do
        let(:tag) { FactoryBot.create(:tag, name: "Foo") }

        let :params do
          { tags: [tag.id] }
        end

        it "redirects to the petition page" do
          expect(response).to redirect_to("https://moderate.demokra.si/admin/archived/petitions/#{petition.id}")
        end

        it "sets the flash notice message" do
          expect(flash[:notice]).to eq("Petition has been successfully updated")
        end

        it "sets the tags attribute" do
          expect(petition.reload.tags).to eq([tag.id])
        end
      end
    end
  end
end
