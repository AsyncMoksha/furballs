//
//  Achievement.h
//  PAWS
//
//  Created by Joseph Crotchett on 10/30/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserProfile;

@interface Achievement : NSManagedObject

@property (nonatomic, retain) NSString * achievedDescription;
@property (nonatomic, retain) NSNumber * achievementID;
@property (nonatomic, retain) NSNumber * achievementLetterIndex;
@property (nonatomic, retain) NSString * achievementName;
@property (nonatomic, retain) NSNumber * achievementPercentCompleted;
@property (nonatomic, retain) NSString * unachievedDescription;
@property (nonatomic, retain) UserProfile *userProfile;

@end
