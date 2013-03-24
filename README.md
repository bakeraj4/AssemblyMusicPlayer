AssemblyMusicPlayer
===================

A MIPS Assembly music player.

The purpose of the musicPlayer is to make the computer beep according to a text file that is named 'sampleMusic.txt'. The first line in the text file is a three digit number that corresponds to the number of notes going to be played, from 001 to 999. It knows the notes D, E, F, G, B, C, and C #. Type the first seven characters to get their corresponding note and any other note to get a C#. It is written in assembly to utilize the syscall 33 that plays a note and waits to continue until after the beep.
