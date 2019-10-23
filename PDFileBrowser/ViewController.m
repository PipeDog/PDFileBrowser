//
//  ViewController.m
//  PDFileBrowser
//
//  Created by liang on 2018/3/29.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "ViewController.h"
#import "PDFileBrowser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)didClickButton:(id)sender {
    [[PDFileBrowser defaultBrowser] presentFileBrowser:NO];
}

@end
