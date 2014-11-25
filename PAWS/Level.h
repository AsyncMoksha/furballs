//
//  Level.h
//  PAWS
//
//  Created by Joseph Crotchett on 10/13/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserProfile;

@interface Level : NSManagedObject

@property (nonatomic, retain) NSNumber * levelID;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) UserProfile *userProfile;

@end
