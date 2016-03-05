//
//  ViewController.m
//  WartezeitenHeilbronn
//
//  Created by Rapante MacBook on 05.03.16.
//  Copyright © 2016 Christian Podlipny. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize visitorsLabel, waitLabel, nextCallLabel, TimeStampLabel, waitView, audioPlayer;
NSInteger timerInt;
NSInteger warteZeitVon;
NSInteger warteZeitNach;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self getWaitTime];
    [NSTimer scheduledTimerWithTimeInterval:10 target: self selector:@selector(getWaitTime) userInfo: self repeats: YES];
    
}

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
    MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    //view.center = CGPointMake(self.view.center.x , view.center.y);
    
    return view;
}


-(void)waitTimerCircle {
    
    timerInt++;
    NSLog(@"%ld", (long)timerInt);
    CGRect frame = CGRectMake(0, 0, 150, 150);
    MDRadialProgressView *myview = [self progressViewWithFrame:frame];
    myview.progressTotal = warteZeitNach;
    myview.progressCounter = timerInt;
    myview.theme.incompletedColor = [UIColor colorWithRed:0.72 green:0.69 blue:0.6 alpha:1];
    myview.theme.completedColor = [UIColor colorWithRed:0.49 green:0.6 blue:0.39 alpha:1];
    myview.theme.sliceDividerHidden = YES;
    [waitView addSubview:myview];
    
    NSLog(@"Sekunden: %ld",(long)warteZeitNach);
    
    if (timerInt == warteZeitNach) {
        timerInt = 0;
        [self EndWaitungSound:@"ring"];
    }
}

-(void)getWaitTime {
    
    NSString *temp = [NSString stringWithFormat:@"http://www.landkreis-heilbronn.de/zulassung/kfz.json"];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:temp];
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                             NSString *temp = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                            NSLog(@"%@", temp);
                                                            NSArray *myArray = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
                                                            
                                                            NSDictionary *json = [myArray objectAtIndex:0];
                                                            NSString *temp1 = [json objectForKey:@"visitors"];
                                                            NSString *temp2 = [json objectForKey:@"wait"];
                                                            NSString *temp3 = [json objectForKey:@"nextcall"];
                                                            NSString *temp4 = [json objectForKey:@"lastupdate"];
                                                            
                                                            warteZeitVon = 0;
                                                            warteZeitVon = [temp2 intValue]*60;
                                                            NSLog(@"WarteZeitVon %ld", (long)warteZeitVon);
                                                            
                                                        visitorsLabel.text = [NSString stringWithFormat:@"Besucher: %@",temp1];
                                                        waitLabel.text = [NSString stringWithFormat:@"Wartezeit: %@",temp2];
                                                        nextCallLabel.text = [NSString stringWithFormat:@"Nächste Nummer: %@",temp3];
                                                        TimeStampLabel.text = [NSString stringWithFormat:@"Zeitstempel: %@",temp4];
                                                        }
                                                       
                                                    }];
    [dataTask resume];
}

-(IBAction)GetTicket:(id)sender {
    
    [self AlertView:@"Ticket" message:@"Sind sie bereits in der Zulassungsstelle und möchten Sie ein virtuelles Ticket ziehen? Es wird Ihnen dann die aktuelle Wartezeit für Sie angezeigt." cancelButton:nil JaButton:@"Ja, bitte!" NeinButton:@"Nein, danke!" alertTag:0];
    
    
}

-(void)EndWaitungSound:(NSString*)soundFile {
    NSLog(@"DINGDONG");
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:soundFile
                                         ofType:@"mp3"]];
    
    audioPlayer = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:url
                                  error:nil];
    [audioPlayer play];
}

-(void)AlertView:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButton JaButton:(NSString *)JaButton NeinButton:(NSString *)NeinButton alertTag:(int)alertTag{
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:JaButton, NeinButton, cancelButton, nil];
    [alertView show];
    alertView.tag = alertTag;
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if(alertView.tag == 0)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"Ja");
            warteZeitNach = warteZeitVon;
            [NSTimer scheduledTimerWithTimeInterval:1 target: self selector:@selector(waitTimerCircle) userInfo: self repeats: YES];
            
        }
        if (buttonIndex == 1)
        {
            NSLog(@"Nein");
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
