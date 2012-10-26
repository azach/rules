ActiveAdmin.register Order do
  show do |f|
    attributes_table do
      row :id
      row :quantity
      row :price
      row :customer
      row :placed
      row :shipped
      row :created_at
      row :updated_at
    end

    show_rules
  end

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
