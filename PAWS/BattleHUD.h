//
//  BattleHUDLayer.h
//  PAWS
//
//  Created by Zinan Xing on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>



#import "Unit.h"
#import "GhostCat.h"
#import "JumpingCat.h"
#import "ItemClass.h"
#import "Catapult.h"

#define kDebugUnit NO


@interface BattleHUDLayer : CCLayer {
    Unit *_selSprite;
    ItemClass *_selItem;
    Unit *_selShadow;
    
    // Selectable Unit
    NSMutableArray *selectableUnits;
    // Selectable Item
    NSMutableArray *selectableItems;
    
    //Test animation
    CCSprite *_enemy;
    CCAction *_walkAction;
    CCAction *_moveAction;
    BOOL _moving;
    
    // For debug
    CCLabelBMFont *playerCoinsLabel;
    CCLabelBMFont *playerHPLabel;
    CCLabelBMFont *enemyHPLabel;
    CCSprite *hpBarCats;
    CCSprite *hpBarDogs;
    
  }

-(void) initUnitBuilderWithArray: (NSMutableArray*) unitArray;
-(void) initItemWithArray: (NSMutableArray*) itemArray;
-(void) updateCoin;
-(void) ccFillPoly:(CGPoint*)poli withPointCount:(int)points isClosed:(BOOL)closePolygon;
/*
- (void) initUnit;
- (void) initUnitSelect: (NSMutableArray*)unitArray;
@property (nonatomic, retain) CCSprite *enemy;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;
@property (nonatomic, retain) NSMutableArray *selectableUnits;
*/

@property (nonatomic, retain) Unit *selSprite;
@property (nonatomic, retain) ItemClass *selItem;
@property (nonatomic, retain) Unit *selShadow;

@property (nonatomic, retain) NSMutableArray *selectableUnits;
@property (nonatomic, retain) NSMutableArray *selectableItems;
@property (nonatomic, retain) CCLabelBMFont *playerCoinsLabel;
@property (nonatomic, retain) CCLabelBMFont *playerHPLabel;
@property (nonatomic, retain) CCLabelBMFont *enemyHPLabel;

@end



