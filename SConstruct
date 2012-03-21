import os

env = Environment(CC = 'clang', CFLAGS=Split(ARGUMENTS.get('CFLAGS'))+['-include', 'NSSet-Examples.pch'])

env.AppendUnique(FRAMEWORKS=Split('Foundation'))
env.AppendUnique(CFLAGS=['-fobjc-arc'], CPPPATH=['ArgumentParser/ArgumentParser/', 'ConsoleUtils/src/', 'NSContainers+PrettyPrint/PrettyPrint/'], CPPDEFINES=['DEBUGPRINT_ALL'])

ConsoleUtils = Glob('ConsoleUtils/src/*.m')
PrettyPrint = Glob('NSContainers+PrettyPrint/PrettyPrint/*.m')
ArgumentParser = Glob('ArgumentParser/ArgumentParser/*.m')

env.Program('speedTest', ['SpeedTest.m', 'Profiler.m']+ConsoleUtils+PrettyPrint+ArgumentParser)
env.Program('lookupTest', ['LookupTest.m']+ConsoleUtils+PrettyPrint)