class MigrateInlineColorsToSylClasses < ActiveRecord::Migration[8.1]
  def up
    Article.where("formatted_content LIKE '%style=%'").find_each do |article|
      counter = 0
      cleaned = article.formatted_content.gsub(/<span style='color:[^']*'>/) do
        cls = "syl-#{counter % 3}"
        counter += 1
        "<span class='#{cls}'>"
      end
      article.update_column(:formatted_content, cleaned)
    end
  end

  def down
    # irreversible : on ne remet pas les couleurs hardcodées
  end
end
