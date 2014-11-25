//
//  BattleGUILayer.h
//  PAWS
//
//  Created by Phisit Jorphochaudom on 10/5/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>
#import "ConsoleLayer.h"
#import "ItemClass.h"


#define BGTAG 0
#define MENUTAG 1
#define kDebugButton YES
@interface BattleGUILayer : CCLayer
{
    BOOL isConsoleOpen;
    BOOL isAdded;
    ConsoleLayer *consoleLayer;
}

+(id) nodeWithLevelID:(NSInteger)lid;
-(id) initWithLevelID:(NSInteger)lid; 
-(void) initConsoleWithArray: (NSMutableArray*) array;

@property (nonatomic, assign) BOOL isConsoleOpen;
@property (nonatomic, assign) BOOL isAdded;
@property (nonatomic, retain) CCLayer *consoleLayer;

@end
