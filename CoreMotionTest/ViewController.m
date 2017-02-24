//
//  ViewController.m
//  CoreMotionTest
//
//  Created by Yioks-Mac on 17/2/23.
//  Copyright © 2017年 Yioks-Mac. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <math.h>

@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) UIView *ball;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    
//    self.ball = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//    self.ball.backgroundColor = [UIColor redColor];
//    
//    self.motionManager = [[CMMotionManager alloc]init];
//    //加速度器的检测
//    if ([self.motionManager isAccelerometerAvailable]) {
//        NSLog(@"accelerometer is available");
//        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
////            self.textView.text = [NSString stringWithFormat:@"x = %.4f, y = %.4f, z = %.4f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z];
//            NSLog(@"x = %.4f, y = %.4f, z = %.4f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z);
//            CGPoint p = self.ball.center;
//            p.x += accelerometerData.acceleration.x;
//            p.y += accelerometerData.acceleration.y;
//            if (p.x < 0) {
//                p.x = self.ball.bounds.size.width / 2;
//            }
//            if (p.y < 0) {
//                p.y = self.ball.bounds.size.height / 2;
//            }
//            
//            if (p.x > self.view.bounds.size.width) {
//                p.x = self.view.bounds.size.width - self.ball.bounds.size.width / 2;
//            }
//            
//            if (p.y > self.view.bounds.size.height) {
//                p.y = self.view.bounds.size.height - self.ball.bounds.size.height / 2;
//            }
//            self.ball.center = p;
//            
//        }];
//    }
//
    //陀螺仪
//    if ([self.motionManager isGyroAvailable]) {
//        [self.motionManager setGyroUpdateInterval:2];
//        [self.motionManager startGyroUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
//            NSLog(@"x = %.4f, y = %.4f, z = %.4f", gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z);
//        }];
//        [self.motionManager startGyroUpdates];
//    }
    
    self.motionManager = [[CMMotionManager alloc]init];
    self.motionManager.deviceMotionUpdateInterval = 0.2;
    [self.motionManager startDeviceMotionUpdates];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
     CMAttitude *initialAttitude = self.motionManager.deviceMotion.attitude;
    NSArray *arr = @[[UIColor redColor], [UIColor blueColor], [UIColor purpleColor], [UIColor orangeColor]];
    __block int index = 0;
    
    
    __block BOOL showingPrompt = NO;
    double showPromptTrigger = 1.0f;
    double showAnswerTrigger = 0.8f;
    
    if (self.motionManager.deviceMotionAvailable) {
        self.motionManager.deviceMotionUpdateInterval = 0.02;
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            
            __weak typeof(self) weakSelf = self;
            
            if (motion.userAcceleration.x < -2.5f) {
                self.view.backgroundColor = [UIColor greenColor];
            }
            
            // translate the attitude
            [motion.attitude multiplyByInverseOfAttitude:initialAttitude];
            // calculate magnitude of the change from our initial attitude
            double magnitude = [self magnitudeFromAttitude:motion.attitude];
            // show the prompt
            if (!showingPrompt && (magnitude > showPromptTrigger)) {
                showingPrompt = YES;
                index ++;
                self.view.backgroundColor = arr[index % 4];
                
            }
            // hide the prompt
            if (showingPrompt && (magnitude < showAnswerTrigger)) {
                showingPrompt = NO;
                index ++;
                self.view.backgroundColor = arr[index % 4];
            }
            
        }];
    }
}


- (double)magnitudeFromAttitude:(CMAttitude *)attitude {
    return sqrt(pow(attitude.roll, 2.0f) + pow(attitude.yaw, 2.0f) + pow(attitude.pitch, 2.0f));
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CMGyroData *gyroData = self.motionManager.gyroData;
    NSLog(@"x = %.4f, y = %.4f, z = %.4f", gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
