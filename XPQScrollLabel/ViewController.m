//
//  ViewController.m
//  XPQScrollLabel
//
//  Created by 谢攀琪 on 15/7/18.
//  Copyright (c) 2015年 谢攀琪. All rights reserved.
//

#import "ViewController.h"
#import "XPQScrollLabel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet XPQScrollLabel *repeatView;
@property (weak, nonatomic) IBOutlet XPQScrollLabel *clickView;
@property (weak, nonatomic) IBOutlet XPQScrollLabel *banView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.repeatView.type = XPQScrollLabelTypeRepeat;
    self.clickView.type = XPQScrollLabelTypeClick;
    self.banView.type = XPQScrollLabelTypeBan;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
