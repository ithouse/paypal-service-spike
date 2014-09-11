module PaypalService
  module DataTypes
    Endpoint = Struct.new(:endpoint_name) # One of :live or :sandbox
    APICredentials = Struct.new(:username, :password, :signature, :app_id)

    FailureResponse = Struct.new(:success, :error_code, :error_msg)

    module_function

    def create_endpoint(type)
      raise(ArgumentError, "type must be either :live or :sandbox") unless [:live, :sandbox].include?(type)
      Endpoint.new(type)
    end

    def create_api_credentials(username, password, signature, app_id)
      raise(ArgumentError, "username, password, signature and app_id are all mandatory.") unless none_empty?(username, password, signature, app_id)
      APICredentials.new(username, password, signature, app_id)
    end

    def none_empty?(*args)
      args.map(&:to_s).reject(&:empty?).length == args.length
    end

    def create_failure_response(error_code, error_msg)
      FailureResponse.new(false, error_code, error_msg)
    end


    module Merchant
      CreateBillingAgreement = Struct.new(:method, :token)

      SetupBillingAgreement = Struct.new(:method, :description, :success, :cancel)
      SetupBillingAgreementResponse = Struct.new(:success, :token, :redirect_url)

      CreateBillingAgreement = Struct.new(:method, :token)
      CreateBillingAgreementResponse = Struct.new(:billing_agreement_id)


      module_function

      def create_setup_billing_agreement(description, success, cancel)
        ParamUtils.throw_if_any_empty({description: description, success: success, cancel: cancel})

        SetupBillingAgreement.new(
          :setup_billing_agreement,
          description,
          success,
          cancel)
      end

      def create_setup_billing_agreement_response(token, redirect_url)
        ParamUtils.throw_if_any_empty({token: token, redirect_url: redirect_url})
        SetupBillingAgreementResponse.new(true, token, redirect_url)
      end

      def create_create_billing_agreement(token)
        ParamUtils.throw_if_any_empty({token: token})
        CreateBillingAgreement.new(:create_billing_agreement, token)
      end

      def create_create_billing_agreement_response(billing_agreement_id)
        ParamUtils.throw_if_any_empty({billing_agreement_id: billing_agreement_id})
        CreateBillingAgreementResponse.new(billing_agreement_id)
      end
    end

    module Permissions
      RequestPermissions = Struct.new(:method, :scope, :callback)
      RequestPermissionsSuccessResponse = Struct.new(:success, :username_to, :scope, :request_token, :redirect_url)
      RequestPermissionsFailureResponse = Struct.new(:success, :error_id, :error_msg)


      module_function

      def create_req_perm(callback)
        raise(ArgumentError, "callback is mandatory") unless DataTypes.none_empty?(callback)

        RequestPermissions.new(
          :request_permissions,
          [
            "EXPRESS_CHECKOUT",
            "AUTH_CAPTURE",
            "REFUND",
            "TRANSACTION_DETAILS",
            "EXPRESS_CHECKOUT",
            "RECURRING_PAYMENTS",
            "SETTLEMENT_REPORTING",
            "RECURRING_PAYMENT_REPORT"
          ],
          callback)
      end

      def create_req_perm_response(username_to, scope, token, redirect_url)
        unless DataTypes.none_empty?(username_to, scope, token, redirect_url)
          raise(ArgumentError, "username_to, scope, token and redirect_url are all mandatory")
        end

        RequestPermissionsSuccessResponse.new(true, username_to, scope, token, redirect_url)
      end

      def create_failed_req_perm_response(error_id, error_msg)
        RequestPermissionsFailureResponse.new(false, error_id, error_msg)
      end
    end
  end
end
