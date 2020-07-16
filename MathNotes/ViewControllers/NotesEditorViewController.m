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
@end

@implementation NotesEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // HTML Content to set in the editor
    self.formatHTML = NO;
    
    UIButton *noteNamebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noteNamebutton setTitle:self.note.noteName forState:UIControlStateNormal];
    [noteNamebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [noteNamebutton addTarget:self action:@selector(changeNoteName) forControlEvents:UIControlEventTouchUpInside];
    noteNamebutton.frame = CGRectMake(0, 0, self.view.frame.size.width, 64.0);
    self.navigationItem.titleView =noteNamebutton;
    
    [self setHTML:self.note.htmlText];
}

- (IBAction)saveProgess:(id)sender {
    [self getHTML:^(NSString *result, NSError * _Nullable error) {
        self.note.htmlText = result;
        [Note updateNote:self.note withCompletion:nil];
    }];
}

- (void)changeNoteName {
    self.note.noteName = @"changed Name";
    UIButton *noteNamebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noteNamebutton setTitle:self.note.noteName forState:UIControlStateNormal];
    [noteNamebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [noteNamebutton addTarget:self action:@selector(changeNoteName) forControlEvents:UIControlEventTouchUpInside];
    noteNamebutton.frame = CGRectMake(0, 0, self.view.frame.size.width, 64.0);
    self.navigationItem.titleView =noteNamebutton;
}
- (IBAction)addEquation:(id)sender {
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
