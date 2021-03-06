//
//  BlinkyView.h
//  Blinky
//
//  Created by David Robinson on 08-FEB-02018.
//  Edited  by David Robinson on 20-FEB-02018.
//  Copyright © 2018 Imperfect Code. All rights reserved.
//
//  Originally based on the tutorial "Write a Screen Saver: Part I" by Brian Christensen
//  http://cocoadevcentral.com/articles/000088.php
//
//  Heavily modified by David Robinson
//


#import <ScreenSaver/ScreenSaver.h>

@interface BlinkyView : ScreenSaverView
{
    IBOutlet id configSheet;
    IBOutlet id drawFilledShapesOption;
    IBOutlet id drawOutlinedShapesOption;
    IBOutlet id drawBothOption;
    IBOutlet id debugModeOption;
}

@end
