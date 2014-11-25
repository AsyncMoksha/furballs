//
//  DialogueTest.h
//  PAWS
//
//  Created by Pisit Praiwattana on 10/24/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DialogLayer.h"
#import "EventLayer.h"
@interface DialogGUILayer :CCLayer
@end

@interface DialogueTest : CCScene {
    DialogGUILayer *_guilayer;
    DialogLayer *_layer;
    EventLayer *_event;
}
@property (nonatomic,retain) DialogGUILayer *guilayer;
@property (nonatomic,retain) DialogLayer *layer;
@property (nonatomic,retain) EventLayer *event;
@end
