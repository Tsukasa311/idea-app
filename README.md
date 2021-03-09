# categories テーブル
| Column     | Type     | Option     |
|------------|----------|------------|
| name       | string   |null: false |

## Association
category has_many :ideas

# ideas テーブル
| Column      | Type       | Option                         |
|-------------|------------|--------------------------------|
| category_id | references | null: false, foreign_key: true |
| body        | text       | null: false                    |

## Association
idea belongs_to :category