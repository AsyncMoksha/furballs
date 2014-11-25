//
//  UserProfile.h
//  PAWS
//
//  Created by Joseph Crotchett on 10/28/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card, Item, Level, Achievement;

@interface UserProfile : NSManagedObject

@property (nonatomic, retain) NSNumber * attackDamageLevel;
@property (nonatomic, retain) NSNumber * attackDamagePercentage;
@property (nonatomic, retain) NSNumber * attackSpeedLevel;
@property (nonatomic, retain) NSNumber * attackSpeedPercentage;
@property (nonatomic, retain) NSNumber * campaign;
@property (nonatomic, retain) NSNumber * coins;
@property (nonatomic, retain) NSNumber * hitPointLevel;
@property (nonatomic, retain) NSNumber * hitPointPercentage;
@property (nonatomic, retain) NSNumber * movementSpeedLevel;
@property (nonatomic, retain) NSNumber * movementSpeedPercentage;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * spawnRateLevel;
@property (nonatomic, retain) NSNumber * spawnRatePercentage;
@property (nonatomic, retain) NSSet *cards;
@property (nonatomic, retain) NSSet *levels;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *achievements;

- (Achievement*) getAchievementByID:(NSInteger)aID;

@end

@interface UserProfile (CoreDataGeneratedAccessors)

- (void)addCardsObject:(Card *)value;
- (void)removeCardsObject:(Card *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;
- (void)addLevelsObject:(Level *)value;
- (void)removeLevelsObject:(Level *)value;
- (void)addLevels:(NSSet *)values;
- (void)removeLevels:(NSSet *)values;
- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;
- (void)addAchievementsObject:(Achievement *)value;
- (void)removeAchievementsObject:(Achievement *)value;
- (void)addAchievements:(NSSet *)values;
- (void)removeAchievements:(NSSet *)values;
@end
