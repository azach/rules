ActiveAdmin.register Order do
  form do |f|
    f.inputs 'Details' do
      f.input :quantity
      f.input :price
      f.input :customer
      f.input :placed
      f.input :shipped
    end

    f.has_rules

    f.buttons
  end
end