class ChargesController < ApplicationController
    def new
        @stripe_btn_data = {
            key: "#{ Rails.configuration.stripe[:publishable_key] }",
            description: "Premium Membership - #{current_user.email}",
            amount: def_amount
        }
    end
    
    
    def create
        # Creates a Stripe Customer object, for associating
        # with the charge
        customer = Stripe::Customer.create(
            email: current_user.email,
            card: params[:stripeToken]
        )
        
        # Where the real magic happens
        charge = Stripe::Charge.create(
            customer: customer.id, # Note -- this is NOT the user_id in your app
            amount: def_amount,
            description: "Premium Membership - #{current_user.email}",
            currency: 'usd'
        )
        
        # Upgrades user account
        
        current_user.premium!
        
        flash[:notice] = "Congrats, #{current_user.email}! You have successfully upgraded your account."
        redirect_to root_path
        
        # Stripe will send back CardErrors, with friendly messages
        # when something goes wrong.
        # This `rescue block` catches and displays those errors.
        rescue Stripe::CardError => e
            flash[:alert] = e.message
            redirect_to new_charge_path
    end
    
     def downgrade
        current_user.standard!
        flash[:notice] = "You have been downgraded. No more money =/"
        redirect_to root_path
    end
    
    def def_amount
        10_00
    end
end
