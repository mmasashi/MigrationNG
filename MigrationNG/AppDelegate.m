//
//  AppDelegate.m
//  MigrationNG
//
//  Created by Miyazaki Masashi on 11/11/02.
//  Copyright (c) 2011 mmasashi.jp. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

- (void)doTask;

@end


@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)dealloc
{
  [_window release];
  [__managedObjectContext release];
  [__managedObjectModel release];
  [__persistentStoreCoordinator release];
    [super dealloc];
}

#pragma mark - Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
  
    [self doTask];
  
    return YES;
}

#pragma mark -

- (void)doTask {
  
  // Copy MigrationNG.sqlite(model version 3) to documents directory.
  [self copySqliteToDocumentsDir];
  
  // Migration -> called Mapping1to4 mapping model and MigrationPolicy1to4.
  [self managedObjectContext];
  
}

- (void)copySqliteToDocumentsDir {
  static NSString * const sqliteFile = @"MigrationNG.sqlite";
  
  NSURL *srcSqliteUrl = [[NSBundle mainBundle] URLForResource:sqliteFile
                                                   withExtension:@""];
  NSURL *dstSqliteUrl = [[self applicationDocumentsDirectory]
                         URLByAppendingPathComponent:sqliteFile];
 
  // remove if MigrationNG.sqlite exists already.
  [[NSFileManager defaultManager] removeItemAtURL:dstSqliteUrl error:nil];
  
  // copy MigrationNG.sqlite
  NSError *error = nil;
  if ([[NSFileManager defaultManager] copyItemAtURL:srcSqliteUrl
                                              toURL:dstSqliteUrl
                                              error:&error]) {
    return;
  }
  
  NSLog(@"Error:%@", [error description]);
  abort();
}


#pragma mark - CoreData handle

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MigrationNG" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MigrationNG.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  
  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
      [NSNumber numberWithBool:NO], NSInferMappingModelAutomaticallyOption,
                           nil];
  
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
