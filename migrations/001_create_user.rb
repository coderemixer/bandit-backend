Sequel.migration do
  transaction
  change do
    create_table(:users) do
      primary_key :id
      String :username, size: 255, null: false, unique: true
      String :password, text: true, null: false
      String :nickname, text: true, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
      TrueClass :is_admin, null: false, default: false
    end
  end
end
