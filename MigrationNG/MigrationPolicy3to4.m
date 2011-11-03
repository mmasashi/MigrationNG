//
//  MigrationPolicy3to4.m
//  MigrationNG
//
//  Created by Miyazaki Masashi on 11/11/03.
//  Copyright (c) 2011 mmasashi.jp. All rights reserved.
//

#import "MigrationPolicy3to4.h"

@implementation MigrationPolicy3to4

- (BOOL)beginEntityMapping:(NSEntityMapping *)mapping
                   manager:(NSMigrationManager *)manager
                     error:(NSError **)error {
  NSLog(@"%s IN", __func__);
  return YES;
}

@end
