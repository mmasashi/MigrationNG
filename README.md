
MigrationNG
-------------
This project is a CoreData migration NG sample that invalid mapping model would be called.
Don't use these sources for your project.

What's NG?
-------------

MigrationNG project has a CoreData model including 4 versions and 2 mapping models(ver1to4, and ver3to4). Now current CoreData model version is 4.
After running app, app copies ver3 sqlite to documents and start migration. On the migration step, ver1->ver4 mapping model would be called, although ver3->ver4 mapping model exists.
I suppose that the migration manager ignores source model version you can see on Xcode, and refers a group of mapping definition for each entity.
