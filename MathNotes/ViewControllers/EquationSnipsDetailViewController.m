//
//  EquationSnipsDetailViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/17/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "EquationSnipsDetailViewController.h"
#import "MTMathUILabel.h"
#import "MTFontManager.h"
@import Parse;

@interface EquationSnipsDetailViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet MTMathUILabel *equationLabel;
@property (weak, nonatomic) IBOutlet UITextView *laTexCodeView;
@property (strong, nonatomic) UIButton *equationSnipNameButton;
@property (weak, nonatomic) IBOutlet UIProgressView *confidenceBar;

@end

@implementation EquationSnipsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    // Do any additional setup after loading the view.
   
    self.equationSnipNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.equationSnipNameButton setTitle:self.equationSnip.equationSnipName forState:UIControlStateNormal];
    [self.equationSnipNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.equationSnipNameButton addTarget:self action:@selector(changeEquationSnipName) forControlEvents:UIControlEventTouchUpInside];
    self.equationSnipNameButton.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 64.0);
    self.navigationItem.titleView =self.equationSnipNameButton;
    
    
    NSString *latex = self.equationSnip.laTeXcode;
    self.equationLabel.latex= [self preparedPreview:latex];
    self.equationLabel.textAlignment = kMTTextAlignmentCenter;
    self.equationLabel.font = [[MTFontManager fontManager] termesFontWithSize:15];
    if (self.equationLabel.error!=nil){
        self.equationLabel.latex = @"\\text{ Preview Unavailable. Tap to learn more. }";
        self.equationLabel.font = [[MTFontManager fontManager] termesFontWithSize:15];
        self.equationLabel.textColor = [UIColor redColor];
        UIButton *previewButton = [[UIButton alloc] init];
        [self.equationLabel addSubview: previewButton];
         [previewButton addTarget:self action:@selector(alertPreviewMessage) forControlEvents:UIControlEventTouchUpInside];
         previewButton.frame = CGRectMake(0, 0, self.equationLabel.frame.size.width, self.equationLabel.frame.size.height);
    }
    if ([self.equationSnip.confidence floatValue]<0.35){
        [self.confidenceBar setProgressTintColor:[UIColor redColor]];
    }
    else if ([self.equationSnip.confidence floatValue] < 0.75){
        [self.confidenceBar setProgressTintColor:[UIColor orangeColor]];
    }
    else{
        [self.confidenceBar setProgressTintColor:[UIColor greenColor]];
    }
    
    [self.confidenceBar setProgress:[self.equationSnip.confidence floatValue] animated:YES];
    
    [self.imageView setFile:self.equationSnip.equationImage];
    [self.imageView loadInBackground];
    
    self.laTexCodeView.text = self.equationSnip.laTeXcode;
}

-(void)alertPreviewMessage {
    NSLog(@"%@",@"Sad");
}

- (NSString *)preparedPreview:(NSString *)latex {
    return [latex stringByReplacingOccurrencesOfString:@"\\text {" withString:@"\\text{"];
}


- (void)changeEquationSnipName {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Rename Equation Snip"
                                                                                  message: @""
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.text = self.equationSnip.equationSnipName;
        textField.clearsOnInsertion =YES;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        self.equationSnip.equationSnipName = namefield.text;
        [self.equationSnipNameButton setTitle:self.equationSnip.equationSnipName forState:UIControlStateNormal];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end