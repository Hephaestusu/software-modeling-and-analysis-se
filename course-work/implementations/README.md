Факултетен номер: **2201321095**

Име на проекта: **Discord – Online Community Platform**

## Описание на проекта

Това е учебен проект, който моделира опростена версия на платформа тип Discord.  
Системата позволява управление на потребители, сървъри, роли, канали и съобщения.

В проекта са включени:

- OLTP релационна база данни (MS SQL Server)
- Концептуален, логически и физически модел (draw.io диаграми)
- Data Warehouse модел
- Съхранена процедура, функция и тригер
- Примерни данни и тестови заявки
- Power BI отчет с визуализации върху данните

---

## Инсталация и стартиране

### 1. Изисквания
- Microsoft SQL Server + SSMS  
- Power BI Desktop  
- diagrams.net (или друга програма за отваряне на `.drawio` файлове)

---

### 2. Създаване на базата данни

1. Отворете папката **Discord/SQL**.
2. Изпълнете файловете в следния ред:

   1. `1-Initialization.sql` – създава базата и всички таблици  
   2. `2-Functions.sql` – добавя потребителската функция  
   3. `3-Procedures.sql` – добавя съхранената процедура  
   4. `4-Triggers.sql` – създава тригера и ChannelStats  
   5. `5-Insert_Data.sql` – зарежда примерни данни  
   6. `6-DemoQueries.sql` – примерни справки (по желание)

---

### 3. Power BI

1. Отворете **Discord-PBI.pbix** от папката `Discord/Power BI`.
2. Ако се налага, обновете връзката към вашия локален SQL Server:
   - `Transform data` → `Data source settings`.
3. Натиснете **Refresh**, за да заредите данните.

---

### 4. Диаграми и документация

- Всички диаграми (концептуален, логически, физически, DWH) се намират в  
  **Discord/Discord-model-diagrams**.
- Подробна документация е в **SQLdocumentation.docx**.

---

## Структура на проекта
Discord/
│
├── SQL/
│ ├── 1-Initialization.sql
│ ├── 2-Functions.sql
│ ├── 3-Procedures.sql
│ ├── 4-Triggers.sql
│ ├── 5-Insert_Data.sql
│ ├── 6-DemoQueries.sql
│ └── SQLdocumentation.docx
│
├── Discord-model-diagrams/
│ ├── Conceptual.drawio
│ ├── Conceptual.png
│ ├── Logical.drawio
│ ├── Logical.png
│ ├── Physical.drawio
│ ├── Physical.png
│ ├── DWH.drawio
│ └── DWH.png
│
└── Power BI/
├── Discord-PBI.pbix
└── Screenshots/
