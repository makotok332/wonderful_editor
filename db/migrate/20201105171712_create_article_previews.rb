class CreateArticlePreviews < ActiveRecord::Migration[6.0]
  def change
    create_table :article_previews do |t|
      t.timestamps
    end
  end
end
