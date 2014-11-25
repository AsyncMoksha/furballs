//
//  Item.h
//  PAWS
//
//  Created by Joseph Crotchett on 10/28/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserProfile;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * itemType;
@property (nonatomic, retain) UserProfile *userProfile;

@end
