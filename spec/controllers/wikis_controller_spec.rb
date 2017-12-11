require 'rails_helper'
include RandomData

RSpec.describe WikisController, type: :controller do
    let(:test_user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:admin_user) { create(:user, role: "admin") }
    let(:my_wiki) { create(:wiki, user: test_user) }
    let(:private_wiki) { create(:wiki, user: test_user, private: true) }

    context "guest user" do
        describe "GET #index" do
            it "returns http redirect" do
                get :index
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        describe "GET #show" do
            it "returns http redirect" do
                get :show, id: my_wiki.id
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        describe "GET #new" do
            it "returns http redirect" do
                get :new
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        describe "POST #create" do
            it "returns http redirect" do
                post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        describe "GET #edit" do
            it "returns http redirect" do
                get :edit, id: my_wiki.id
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        describe "PUT #update" do
            it "returns http redirect" do
                put :update, id: my_wiki.id, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        describe "DELETE #destroy" do
            it "returns http redirect" do
                delete :destroy, id: my_wiki.id
                expect(response).to redirect_to(new_user_session_path)
            end
        end
    end

    context "user doing CRUD on a wiki they own" do
        before(:each) do
            sign_in test_user
        end
        
        describe "GET #index" do
            it "returns http success" do
                get :index
                expect(response).to have_http_status(:success)
            end

            it "assigns my_wiki to @wiki" do
                get :index
                expect(assigns(:wiki)).to eq([my_wiki])
            end
        end

        describe "GET #show" do
            it "returns http success" do
                get :show, id: my_wiki.id
                expect(response).to have_http_status(:success)
            end

            it "renders the #show view" do
                get :show, id: my_wiki.id
                expect(response).to render_template :show
            end

            it "assigns my_wiki to @wiki" do
                get :show, id: my_wiki.id
                expect(assigns(:wiki)).to eq(my_wiki)
            end
        end

        describe "GET #new" do
            it "returns http success" do
                get :new
                expect(response).to have_http_status(:success)
            end

            it "renders the #new view" do
                get :new
                expect(response).to render_template :new
            end

            it "initializes @wiki" do
                get :new
                expect(assigns(:wiki)).not_to be_nil
            end
        end

        describe "POST #create" do
            it "increases the number of wikis by 1" do
                expect { post :create, {wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}} }.to change(Wiki,:count).by(1)
            end

            it "assigns Wiki.last to @wiki" do
                post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}
                expect(assigns(:wiki)).to eq(Wiki.last)
            end

            it "redirects to the new wiki" do
                post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}
                expect(response).to redirect_to Wiki.last
            end
        end

        describe "GET #edit" do
            it "returns http success" do
                get :edit, id: my_wiki.id
                expect(response).to have_http_status(:success)
            end

            it "renders the #edit view" do
                get :edit, id: my_wiki.id
                expect(response).to render_template(:edit)
            end

            it "assigns wiki to be updated to @wiki" do
                get :edit, id: my_wiki.id
                wiki_instance = assigns(:wiki)

                expect(wiki_instance.id).to eq my_wiki.id
                expect(wiki_instance.title).to eq my_wiki.title
                expect(wiki_instance.body).to eq my_wiki.body
            end
        end

        describe "PUT #update" do
            it "updates wiki with expected attributes" do
                new_title = RandomData.random_sentence
                new_body = RandomData.random_paragraph

                put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
                updated_wiki = assigns(:wiki)

                expect(updated_wiki.id).to eq my_wiki.id
                expect(updated_wiki.title).to eq new_title
                expect(updated_wiki.body).to eq new_body
            end

            it "redirects to the updated wiki" do
                put :update, id: my_wiki.id, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
                expect(response).to redirect_to my_wiki
            end
        end

        describe "DELETE #destroy" do
            it "deletes the wiki" do
                delete :destroy, id: my_wiki.id
                count = Wiki.where({id: my_wiki.id}).size
                expect(count).to eq(0)
            end

            it "redirects to the wikis index" do
                delete :destroy, id: my_wiki.id
                expect(response).to redirect_to wikis_path
            end
        end
    end

    context "standard user doing CRUD on a public wiki they don't own" do
        before(:each) do
            sign_in other_user
        end
        
        describe "GET #index" do
            it "returns http success" do
                get :index
                expect(response).to have_http_status(:success)
            end

            it "assigns my_wiki to @wiki" do
                get :index
                expect(assigns(:wiki)).to eq([my_wiki])
            end
        end

        describe "GET #show" do
            it "returns http success" do
                get :show, id: my_wiki.id
                expect(response).to have_http_status(:success)
            end

            it "renders the #show view" do
                get :show, id: my_wiki.id
                expect(response).to render_template :show
            end

            it "assigns my_wiki to @wiki" do
                get :show, id: my_wiki.id
                expect(assigns(:wiki)).to eq(my_wiki)
            end
        end

        describe "GET #new" do
            it "returns http success" do
                get :new
                expect(response).to have_http_status(:success)
            end

            it "renders the #new view" do
                get :new
                expect(response).to render_template :new
            end

            it "initializes @wiki" do
                get :new
                expect(assigns(:wiki)).not_to be_nil
            end
        end

        describe "POST #create" do
            it "increases the number of wikis by 1" do
                expect { post :create, {wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}} }.to change(Wiki,:count).by(1)
            end

            it "assigns Wiki.last to @wiki" do
                post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}
                expect(assigns(:wiki)).to eq(Wiki.last)
            end

            it "redirects to the new wiki" do
                post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}
                expect(response).to redirect_to Wiki.last
            end
        end

        describe "GET #edit" do
            it "returns http success" do
                get :edit, id: my_wiki.id
                expect(response).to have_http_status(:success)
            end

            it "renders the #edit view" do
                get :edit, id: my_wiki.id
                expect(response).to render_template(:edit)
            end

            it "assigns wiki to be updated to @wiki" do
                get :edit, id: my_wiki.id
                wiki_instance = assigns(:wiki)

                expect(wiki_instance.id).to eq my_wiki.id
                expect(wiki_instance.title).to eq my_wiki.title
                expect(wiki_instance.body).to eq my_wiki.body
            end
        end

        describe "PUT #update" do
            it "updates wiki with expected attributes" do
                new_title = RandomData.random_sentence
                new_body = RandomData.random_paragraph

                put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
                updated_wiki = assigns(:wiki)

                expect(updated_wiki.id).to eq my_wiki.id
                expect(updated_wiki.title).to eq new_title
                expect(updated_wiki.body).to eq new_body
            end

            it "redirects to the updated wiki" do
                put :update, id: my_wiki.id, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
                expect(response).to redirect_to my_wiki
            end
        end

        describe "DELETE #destroy" do
            it "returns http redirect" do
                delete :destroy, id: my_wiki.id
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end
    end

    context "standard user doing CRUD on a private wiki they don't own" do
        before(:each) do
            sign_in other_user
        end
        
        describe "GET #index" do
            it "returns http success" do
                get :index
                expect(response).to have_http_status(:success)
            end

            it "assigns my_wiki to @wiki" do
                get :index
                expect(assigns(:wiki)).to eq([my_wiki])
            end
        end

        describe "GET #show" do
            it "returns http redirect" do
                get :show, id: private_wiki.id
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end

        describe "GET #new" do
            it "returns http success" do
                get :new
                expect(response).to have_http_status(:success)
            end

            it "renders the #new view" do
                get :new
                expect(response).to render_template :new
            end

            it "initializes @wiki" do
                get :new
                expect(assigns(:wiki)).not_to be_nil
            end
        end

        describe "POST #create" do
            it "increases the number of wikis by 1" do
                expect { post :create, {wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}} }.to change(Wiki,:count).by(1)
            end

            it "assigns Wiki.last to @wiki" do
                post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}
                expect(assigns(:wiki)).to eq(Wiki.last)
            end

            it "redirects to the new wiki" do
                post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}
                expect(response).to redirect_to Wiki.last
            end
        end

        describe "GET #edit" do
            it "returns http redirect" do
                get :edit, id: private_wiki.id
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end

        describe "PUT #update" do
            it "returns http redirect" do
                new_title = RandomData.random_sentence
                new_body = RandomData.random_paragraph

                put :update, id: private_wiki.id, wiki: {title: new_title, body: new_body}
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end

        describe "DELETE #destroy" do
            it "returns http redirect" do
                delete :destroy, id: private_wiki.id
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end
    end

    context "admin doing CRUD on a wiki they don't own" do
        before(:each) do
            sign_in admin_user
        end
        
        describe "GET #index" do
            it "returns http success" do
                get :index
                expect(response).to have_http_status(:success)
            end

            it "assigns my_wiki to @wiki" do
                get :index
                expect(assigns(:wiki)).to eq([my_wiki])
            end
        end

        describe "GET #show" do
            it "returns http success" do
                get :show, id: my_wiki.id
                expect(response).to have_http_status(:success)
            end

            it "renders the #show view" do
                get :show, id: my_wiki.id
                expect(response).to render_template :show
            end

            it "assigns my_wiki to @wiki" do
                get :show, id: my_wiki.id
                expect(assigns(:wiki)).to eq(my_wiki)
            end
        end

        describe "GET #new" do
            it "returns http success" do
                get :new
                expect(response).to have_http_status(:success)
            end

            it "renders the #new view" do
                get :new
                expect(response).to render_template :new
            end

            it "initializes @wiki" do
                get :new
                expect(assigns(:wiki)).not_to be_nil
            end
        end

        describe "POST #create" do
            it "increases the number of wikis by 1" do
                expect { post :create, {wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}} }.to change(Wiki,:count).by(1)
            end

            it "assigns Wiki.last to @wiki" do
                post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}
                expect(assigns(:wiki)).to eq(Wiki.last)
            end

            it "redirects to the new wiki" do
                post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false}
                expect(response).to redirect_to Wiki.last
            end
        end

        describe "GET #edit" do
            it "returns http success" do
                get :edit, id: my_wiki.id
                expect(response).to have_http_status(:success)
            end

            it "renders the #edit view" do
                get :edit, id: my_wiki.id
                expect(response).to render_template(:edit)
            end

            it "assigns wiki to be updated to @wiki" do
                get :edit, id: my_wiki.id
                wiki_instance = assigns(:wiki)

                expect(wiki_instance.id).to eq my_wiki.id
                expect(wiki_instance.title).to eq my_wiki.title
                expect(wiki_instance.body).to eq my_wiki.body
            end
        end

        describe "PUT #update" do
            it "updates wiki with expected attributes" do
                new_title = RandomData.random_sentence
                new_body = RandomData.random_paragraph

                put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
                updated_wiki = assigns(:wiki)

                expect(updated_wiki.id).to eq my_wiki.id
                expect(updated_wiki.title).to eq new_title
                expect(updated_wiki.body).to eq new_body
            end

            it "redirects to the updated wiki" do
                put :update, id: my_wiki.id, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
                expect(response).to redirect_to my_wiki
            end
        end

        describe "DELETE #destroy" do
            it "deletes the wiki" do
                delete :destroy, id: my_wiki.id
                count = Wiki.where({id: my_wiki.id}).size
                expect(count).to eq(0)
            end

            it "redirects to the wikis index" do
                delete :destroy, id: my_wiki.id
                expect(response).to redirect_to wikis_path
            end
        end
    end
end