Sequel.migration do
  transaction
  change do
    create_table(:cards) do
      primary_key :id
      String :question, text: true, null: false
      String :answer, text: true, null: false
      Integer :attempts, null: false, default: 0
      Integer :failures, null: false, default: 0
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
      foreign_key :project_id, :projects, null: false, key: [:id]
    end
  end
end
