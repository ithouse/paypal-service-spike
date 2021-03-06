# == Schema Information
#
# Table name: paypal_payments
#
#  id                         :integer          not null, primary key
#  community_id               :integer          not null
#  transaction_id             :integer          not null
#  payer_id                   :string(64)       not null
#  receiver_id                :string(64)       not null
#  merchant_id                :string(255)      not null
#  order_id                   :string(64)       not null
#  order_date                 :datetime         not null
#  currency                   :string(8)        not null
#  order_total_cents          :integer          not null
#  authorization_id           :string(64)
#  authorization_date         :datetime
#  authorization_expires_date :datetime
#  authorization_total_cents  :integer
#  payment_id                 :string(64)
#  payment_date               :datetime
#  payment_total_cents        :integer
#  fee_total_cents            :integer
#  payment_status             :string(64)       not null
#  pending_reason             :string(64)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  commission_payment_id      :string(64)
#  commission_payment_date    :datetime
#  commission_status          :string(64)       default("not_charged"), not null
#  commission_pending_reason  :string(64)
#  commission_total_cents     :integer
#  commission_fee_total_cents :integer
#
# Indexes
#
#  index_paypal_payments_on_authorization_id  (authorization_id) UNIQUE
#  index_paypal_payments_on_community_id      (community_id)
#  index_paypal_payments_on_order_id          (order_id) UNIQUE
#  index_paypal_payments_on_transaction_id    (transaction_id) UNIQUE
#

class PaypalPayment < ActiveRecord::Base
  # attr_accessible(
  #   :community_id,
  #   :transaction_id,
  #   :payer_id,
  #   :receiver_id,
  #   :merchant_id,
  #   :order_id,
  #   :order_date,
  #   :currency,
  #   :order_total_cents,
  #   :authorization_id,
  #   :authorization_date,
  #   :authorization_expires_date,
  #   :authorization_total_cents,
  #   :payment_id,
  #   :payment_date,
  #   :payment_total_cents,
  #   :fee_total_cents,
  #   :payment_status,
  #   :pending_reason,
  #   :commission_payment_id,
  #   :commission_payment_date,
  #   :commission_total_cents,
  #   :commission_fee_total_cents,
  #   :commission_status,
  #   :commission_pending_reason)

  validates_presence_of(
    :community_id,
    :transaction_id,
    :payer_id,
    :receiver_id,
    :order_id,
    :order_date,
    :currency,
    :order_total_cents,
    :payment_status,
    :commission_status)

  def order_total
    Money.new(order_total, currency)
  end

  def authorization_total
    Money.new(authorization_total, currency)
  end

  def payment_total
    Money.new(payment_total, currency)
  end

  def fee_total
    Money.new(fee_total, currency)
  end

  def commission_total
    Money.new(commission_total, currency)
  end

  def commission_fee_total
    Money.new(commission_fee_total, currency)
  end

  def order_total=(m)
    order_total_cents = m.cents
    currency = m.currency.iso_code
  end

  def authorization_total=(m)
    authorization_total_cents = m.cents
    currency = m.currency.iso_code
  end

  def payment_total=(m)
    payment_total_cents = m.cents
    currency = m.currency.iso_code
  end

  def fee_total=(m)
    fee_total_cents = m.cents
    currency = m.currency.iso_code
  end

  def commission_total=(m)
    commission_total_cents = m.cents
    currency = m.currency.iso_code
  end

  def commission_fee_total=(m)
    commission_fee_total_cents = m.cents
    currency = m.currency.iso_code
  end

end
