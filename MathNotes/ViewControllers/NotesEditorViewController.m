//
//  NotesEditorViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "NotesEditorViewController.h"

@interface NotesEditorViewController ()
@end

@implementation NotesEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // HTML Content to set in the editor
    self.formatHTML = YES;
    [self setHTML:self.note.htmlText];
    
    UIButton *noteNamebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noteNamebutton setTitle:self.note.noteName forState:UIControlStateNormal];
    [noteNamebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [noteNamebutton addTarget:self action:@selector(changeNoteName) forControlEvents:UIControlEventTouchUpInside];
    noteNamebutton.frame = CGRectMake(0, 0, self.view.frame.size.width, 64.0);
    self.navigationItem.titleView =noteNamebutton;
}

- (IBAction)saveProgess:(id)sender {
    [self getHTML:^(NSString *result, NSError * _Nullable error) {
        [Note postNote:@"dummy" withText:result withCompletion:nil];
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

@end
