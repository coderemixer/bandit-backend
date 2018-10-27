Sequel.migration do
  transaction
  change do
    create_table(:projects) do
      primary_key :id
      String :name, size: 255, null: false
      String :description, text: true, null: false
      TrueClass :is_public, null: false, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
      foreign_key :user_id, :users, null: false, key: [:id]
      unique [:user_id, :name]
    end
  end
end
