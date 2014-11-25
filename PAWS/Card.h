//
//  Card.h
//  PAWS
//
//  Created by Joseph Crotchett on 10/14/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserProfile;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSNumber * unitType;
@property (nonatomic, retain) UserProfile *userProfile;

@end
