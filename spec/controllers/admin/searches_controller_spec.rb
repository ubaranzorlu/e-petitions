require 'rails_helper'

RSpec.describe Admin::SearchesController, type: :controller, admin: true do
  context "when not logged in" do
    describe "GET /admin/search" do
      it "redirects to the login page" do
        get :show, params: { type: "petition", q: "foo" }
        expect(response).to redirect_to("https://moderate.demokra.si/admin/login")
      end
    end
  end

  context "when logged in as a moderator but need to reset password" do
    let(:user) { FactoryBot.create(:moderator_user, force_password_reset: true) }
    before { login_as(user) }

    describe "GET /admin/search" do
      it "redirects to the edit profile page" do
        get :show, params: { type: "petition", q: "foo" }
        expect(response).to redirect_to("https://moderate.demokra.si/admin/profile/#{user.id}/edit")
      end
    end
  end

  context "when logged in as a moderator" do
    let(:user) { FactoryBot.create(:moderator_user) }
    before { login_as(user) }

    describe "GET /admin/search" do
      context "when searching for petitions" do
        it "redirects to the petitions search url" do
          get :show, params: { type: "petition", q: "foo" }
          expect(response).to redirect_to("https://moderate.demokra.si/admin/petitions?q=foo")
        end
      end

      context "when searching for petitions with departments" do
        it "redirects to the petitions search url" do
          get :show, params: { type: "petition", q: "foo", depts: ["1"], dmatch: "any" }
          expect(response).to redirect_to("https://moderate.demokra.si/admin/petitions?depts%5B%5D=1&dmatch=any&q=foo")
        end
      end

      context "when searching for petitions with no departments" do
        it "redirects to the petitions search url" do
          get :show, params: { type: "petition", q: "foo", dmatch: "none" }
          expect(response).to redirect_to("https://moderate.demokra.si/admin/petitions?dmatch=none&q=foo")
        end
      end

      context "when searching for petitions with tags" do
        it "redirects to the petitions search url" do
          get :show, params: { type: "petition", q: "foo", tags: ["1"], tmatch: "any" }
          expect(response).to redirect_to("https://moderate.demokra.si/admin/petitions?q=foo&tags%5B%5D=1&tmatch=any")
        end
      end

      context "when searching for petitions with no tags" do
        it "redirects to the petitions search url" do
          get :show, params: { type: "petition", q: "foo", tmatch: "none" }
          expect(response).to redirect_to("https://moderate.demokra.si/admin/petitions?q=foo&tmatch=none")
        end
      end

      context "when searching for petitions with departments and tags" do
        it "redirects to the petitions search url" do
          get :show, params: { type: "petition", q: "foo", depts: ["1"], dmatch: "any", tags: ["1"], tmatch: "any" }
          expect(response).to redirect_to("https://moderate.demokra.si/admin/petitions?depts%5B%5D=1&dmatch=any&q=foo&tags%5B%5D=1&tmatch=any")
        end
      end

      context "when searching for petitions with no departments and tags" do
        it "redirects to the petitions search url" do
          get :show, params: { type: "petition", q: "foo", dmatch: "none", tmatch: "none" }
          expect(response).to redirect_to("https://moderate.demokra.si/admin/petitions?dmatch=none&q=foo&tmatch=none")
        end
      end

      context "when searching for signatures" do
        it "redirects to the signatures search url" do
          get :show, params: { type: "signature", q: "foo" }
          expect(response).to redirect_to("https://moderate.demokra.si/admin/signatures?q=foo")
        end
      end

      context "when searching for signatures in a time period" do
        it "redirects to the signatures search url" do
          get :show, params: { type: "signature", q: "foo", window: "300" }
          expect(response).to redirect_to("https://moderate.demokra.si/admin/signatures?q=foo&window=300")
        end
      end

      context "when searching for an unknown type" do
        it "redirects to the admin dashboard url" do
          get :show, params: { q: "foo" }
          expect(response).to redirect_to("https://moderate.demokra.si/admin")
          expect(flash[:notice]).to eq("Sorry, we didn't understand your query")
        end
      end
    end
  end
end
