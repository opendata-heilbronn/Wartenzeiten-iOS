//
//  ViewController.h
//  WartezeitenHeilbronn
//
//  Created by Rapante MacBook on 05.03.16.
//  Copyright © 2016 Christian Podlipny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <NSURLSessionDelegate,UIAlertViewDelegate>{
    
    AVAudioPlayer *audioPlayer;
}
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain)IBOutlet UIView   *waitView;
@property (nonatomic, retain) IBOutlet UILabel *visitorsLabel;
@property (nonatomic, retain) IBOutlet UILabel *waitLabel;
@property (nonatomic, retain) IBOutlet UILabel *nextCallLabel;
@property (nonatomic, retain) IBOutlet UILabel *TimeStampLabel;

@end

