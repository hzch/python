#!/usr/bin/env python
# vim: set fileencoding=utf8

import os 
import sys
import argparse
from biplist import *

DEFAULTTYPE = "app"
DEFAULTOS = "iOS-10-0"
DEFAULTDEVICE = "iPhone-7"
DEFAULTBUNDLEIDAPP = "BUNDLEID"
DEFAULTBUNDLEIDEXTENSION = "BUNDLEID"
DEFAULTBUNDLEIDGROUP = "BUNDLEID"

PREOSVERSION = "com.apple.CoreSimulator.SimRuntime."
PREDEVCETYPE = "com.apple.CoreSimulator.SimDeviceType."
PLISTFILENAME = ".com.apple.mobile_container_manager.metadata.plist"


def getDevices(allOSVersions, osVersion):
	devices = allOSVersions.get(PREOSVERSION + osVersion)
	if devices == None:
		print 'verison error! All os verisons:'
		for osVersion in allOSVersions.keys():
			if len(osVersion) < len(PREOSVERSION):
				continue
			print osVersion.replace(PREOSVERSION, '')
	return devices

def getDeviceId(allOSVersions, osVersion, device):
	allDevices = getDevices(allOSVersions, osVersion)
	if allDevices == None:
		return allDevices

	deviceId = allDevices.get(PREDEVCETYPE + device)
	if deviceId == None:
		print 'device error! All devices:'
		for device in allDevices.keys():
			if len(device) < len(PREDEVCETYPE):
				continue
			print device.replace(PREDEVCETYPE, '')
	return deviceId

def getApps(deviceDataPath, bundleId):
	apps = []
	bundleIds = []
	allBundleIds = []
	for appId in os.listdir(deviceDataPath) :
		appPlist = os.path.join(deviceDataPath, appId, PLISTFILENAME)
		if os.path.isfile(appPlist) == False:
			continue
		appPlistDic = readPlist(appPlist)
		plistBundleId = appPlistDic['MCMMetadataIdentifier']
		if plistBundleId == bundleId:
			apps = [os.path.join(deviceDataPath, appId)]
			bundleIds = [plistBundleId]
			break
		allBundleIds.append(plistBundleId)
		if plistBundleId.find(bundleId) == 0 :
			apps.append(os.path.join(deviceDataPath, appId))
			bundleIds.append(plistBundleId)
	return apps, bundleIds, allBundleIds

def openApps(apps, bundleIds, allBundleIds) :
	if len(apps) == 0:
		print 'bundleId error! All bundleIds:'
		for bundleId in allBundleIds:
			print bundleId
		return
	if len(apps) == 1:
		os.system('open "{path}"'.format(path=apps[0]))
		print apps[0]
		return
	for plistBundleId in bundleIds:
		print plistBundleId

def gotoDoc(type, osVersion, device, bundleId):
	print 'type:{type}, osVersion:{osVersion}, device:{device}, bundleId:{bundleId}'.format(type=type,osVersion=osVersion,device=device,bundleId=bundleId)
	devicesPath = os.path.join(os.path.expanduser('~'),'Library/Developer/CoreSimulator/Devices/')
	devicesSetPath = os.path.join(devicesPath, 'device_set.plist')
	if os.path.isfile(devicesSetPath) == False:
		print 'Error: Can not find ' + devicesSetPath
		return

	deviceId = getDeviceId(readPlist(devicesSetPath)['DefaultDevices'], osVersion, device)
	if deviceId == None:
		return

	deviceDataPath = os.path.join(devicesPath, deviceId, 'data/Containers/Data/Application')
	if type == 'extension' :
		deviceDataPath = os.path.join(devicesPath, deviceId, 'data/Containers/Data/PluginKitPlugin')
	elif type == 'group' :
		deviceDataPath = os.path.join(devicesPath, deviceId, 'data/Containers/Shared/AppGroup')

	apps,bundleIds,allBundleIds = getApps(deviceDataPath, bundleId)
	openApps(apps, bundleIds, allBundleIds)

def main():
	description = ''' go to simulator documents
	{self_name} -o osVersion -d device -b bundleId -t type '''.format(self_name=sys.argv[0])

	parser = argparse.ArgumentParser(description=description, formatter_class=argparse.RawDescriptionHelpFormatter,)
	parser.add_argument('-t', action='store', dest='type', default=DEFAULTTYPE, help='type: `app`,`extenion`,`group`')
	parser.add_argument('-o', action='store', dest='osVersion', default=DEFAULTOS, help='osVersion: iOS-10-0')
	parser.add_argument('-d', action='store', dest='device', default=DEFAULTDEVICE, help='device: iPhone-7')
	parser.add_argument('-b', action='store', dest='bundleId', help='bundleId: `{bundleId}`'.format(bundleId=DEFAULTBUNDLEIDAPP))
	args = parser.parse_args()

	bundleId = DEFAULTBUNDLEIDAPP
	if args.type == 'extension':
		bundleId = DEFAULTBUNDLEIDEXTENSION
	elif args.type == 'group':
		bundleId = DEFAULTBUNDLEIDGROUP
	if args.bundleId != None:
		bundleId = args.bundleId
	gotoDoc(args.type, args.osVersion, args.device, bundleId)

if __name__ == '__main__':
  main()