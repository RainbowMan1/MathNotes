//
//  NotesEditorViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "NotesEditorViewController.h"
#import "EquationPickerViewController.h"

@interface NotesEditorViewController ()<EquationPickerDelegate>
@property (strong, nonatomic) UIButton *noteNameButton;
@end

@implementation NotesEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    // HTML Content to set in the editor
    self.formatHTML = NO;
    
    self.noteNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.noteNameButton setTitle:self.note.noteName forState:UIControlStateNormal];
    [self.noteNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.noteNameButton addTarget:self action:@selector(changeNoteName) forControlEvents:UIControlEventTouchUpInside];
    self.noteNameButton.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 64.0);
    self.navigationItem.titleView =self.noteNameButton;
    
    [self setHTML:self.note.htmlText];
}

- (IBAction)saveProgess:(id)sender {
    [self getHTML:^(NSString *result, NSError * _Nullable error) {
        self.note.htmlText = result;
        [Note updateNote:self.note withCompletion:nil];
    }];
}

- (void)changeNoteName {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Rename Note"
                                                                                     message: @""
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
       [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
           textField.placeholder = @"name";
           textField.borderStyle = UITextBorderStyleRoundedRect;
           textField.text = self.note.noteName;
           textField.clearsOnInsertion =YES;
       }];
       [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
           NSArray * textfields = alertController.textFields;
           UITextField * namefield = textfields[0];
           NSLog(@"%@",namefield.text);
           self.note.noteName = namefield.text;
           [self.noteNameButton setTitle:self.note.noteName forState:UIControlStateNormal];
       }]];
       [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)didPickEquationSnip:(nonnull EquationSnip *)equationSnip {
    NSLog(@"%@",[equationSnip.equationImage url]);
    [self prepareInsertWithCompletion:^(NSString *result, NSError *error) {
        if (error==nil){
            [self insertImage:[equationSnip.equationImage url]alt:@"Equation"];
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EquationPickerViewController *equationPickerVC = [segue destinationViewController];
    equationPickerVC.delegate = self;
}



@end
