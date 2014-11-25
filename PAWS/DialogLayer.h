//
//  DialogLayer.h
//  PAWS
//
//  Created by Pisit Praiwattana on 10/25/54 BE.
//  Copyright 2554 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum {DIALOG_LABEL_TAG, DIALOGUE_SPEAKER_TAG} DIALOG_TAG;

@interface DialogLayer :CCLayer{
    NSString *_fontFileName;
    NSString *_speakerFileName;
    NSString *_panelFileName;
    NSArray *_msg;
    CCLabelBMFont *_textLabel;
    CCSprite *_dialogPanel;
    CCSprite *_speaker;
    int _currentIndex;
    int _isDialogOpened;
}

-(id) initWithBMFont:(NSString *)fontFileName andDialog: (NSString*)dialogFileName;
-(void) animateSpeakerIn;
-(void) animateDialogIn;
-(void) openStoryDialog;
-(void) closeStoryDialog;
-(void) displayMessageAndPlusIndexBy1;
-(CCLabelBMFont*)labelFromString:(NSString*) myString;
-(NSString*) cleanSyntaxString:(NSString*)originalString;
-(BOOL)loadPlistForMessageDialog:(NSString*) dialogFileName;
@property (nonatomic,retain) NSString *fontFileName;
@property (nonatomic,retain) NSString *speakerFileName;
@property (nonatomic,retain) NSString *panelFileName;
@property (nonatomic,retain) NSArray *msg;
@property (nonatomic,retain) CCLabelBMFont *textLabel;
@property (nonatomic,retain) CCSprite *dialogPanel;
@property (nonatomic,retain) CCSprite *speaker;
@property (nonatomic,assign) int currentIndex;
@property (nonatomic,assign) int isDialogOpened;
@end