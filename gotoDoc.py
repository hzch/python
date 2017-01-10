#!/usr/bin/env python
# vim: set fileencoding=utf8

import os 
import sys
import argparse
from biplist import readPlist

DEFAULTTYPE = "app"
DEFAULTOS = "iOS-10-2"
DEFAULTDEVICE = "iPhone-7"
DEFAULTBUNDLEIDAPP = "d.netease.mailmaster"
DEFAULTBUNDLEIDEXTENSION = "d.netease.mailmaster.shareExtension"
DEFAULTBUNDLEIDGROUP = "group.d.netease.mail"

PREOSVERSION = "com.apple.CoreSimulator.SimRuntime."
PREDEVCETYPE = "com.apple.CoreSimulator.SimDeviceType."
PLISTFILENAME = ".com.apple.mobile_container_manager.metadata.plist"
BUNDLEIDKEY = 'MCMMetadataIdentifier'

SHOWAPPLEBUNDLEID = False

def getDevices(allOSVersions, osVersion):
	devices = allOSVersions.get(PREOSVERSION + osVersion)
	if devices == None:
		print('[E] Version error!')
		print('[I] All os version:\n'+'='*20)
		for osVersion in allOSVersions.keys():
			if len(osVersion) < len(PREOSVERSION):
				continue
			print(osVersion.replace(PREOSVERSION, ''))
		print('='*20)
	else:
		print('[I] Open: osVersion:' + osVersion)
	return devices

def getDeviceId(allOSVersions, osVersion, device):
	allDevices = getDevices(allOSVersions, osVersion)
	if allDevices == None:
		return allDevices

	deviceId = allDevices.get(PREDEVCETYPE + device)
	if deviceId == None:
		print('[E] Device error!')
		print('[I] All devices:\n'+'='*20)
		for device in allDevices.keys():
			if len(device) < len(PREDEVCETYPE):
				continue
			print(device.replace(PREDEVCETYPE, ''))
		print('='*20)
	else:
		print('[I] Open: device:' + device)
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
		plistBundleId = appPlistDic[BUNDLEIDKEY]
		if plistBundleId == bundleId:
			apps = [os.path.join(deviceDataPath, appId)]
			bundleIds = [plistBundleId]
			break

		if not SHOWAPPLEBUNDLEID and plistBundleId.find('com.apple.') != -1:
			continue

		allBundleIds.append(plistBundleId)
		if plistBundleId.find(bundleId) != -1 :
			apps.append(os.path.join(deviceDataPath, appId))
			bundleIds.append(plistBundleId)
	return apps, bundleIds, allBundleIds

def openApps(apps, bundleIds, allBundleIds) :
	if len(apps) == 0:
		print('[E] BundleId error!')
		print('[I] All bundleIds:\n'+'='*20)
		for bundleId in allBundleIds:
			print(bundleId)
		print('='*20)
		return
	if len(apps) == 1:
		print('[I] Open: bundleId:' + bundleIds[0])
		os.system('open "{path}"'.format(path=apps[0]))
		print('[I] Open: ' + apps[0])
		return
	print('[I] BundleIds match!')
	print('[I] Matchs bundleIds:\n'+'='*20)
	for plistBundleId in bundleIds:
		print(plistBundleId)
	print('='*20)

def gotoDoc(type, osVersion, device, bundleId):
	devicesPath = os.path.join(os.path.expanduser('~'),'Library/Developer/CoreSimulator/Devices/')
	devicesSetPath = os.path.join(devicesPath, 'device_set.plist')
	if os.path.isfile(devicesSetPath) == False:
		print('[E] Error: Can not find ' + devicesSetPath)
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
	description = ''' Go to simulator documents, bundleId support partial input.'''

	parser = argparse.ArgumentParser(description=description, formatter_class=argparse.RawDescriptionHelpFormatter,)
	parser.add_argument('-t', action='store', dest='type', default=DEFAULTTYPE, help='type: `app`,`extension`,`group`')
	parser.add_argument('-o', action='store', dest='osVersion', default=DEFAULTOS, help='osVersion: iOS-10-0')
	parser.add_argument('-d', action='store', dest='device', default=DEFAULTDEVICE, help='device: iPhone-7')
	parser.add_argument('-b', action='store', dest='bundleId', help='bundleId: `{bundleId}`'.format(bundleId=DEFAULTBUNDLEIDAPP))
	args = parser.parse_args()

	bundleId = DEFAULTBUNDLEIDAPP
	if args.type == 'extension':
		bundleId = DEFAULTBUNDLEIDEXTENSION
	elif args.type == 'group':
		bundleId = DEFAULTBUNDLEIDGROUP
	elif args.type == 'app':
		bundleId = DEFAULTBUNDLEIDAPP
	else:
		print("[E] Type error! Please input `app`,`extension` or `group`.")
		return;
	print('[I] Open: type:' + args.type)
	if args.bundleId != None:
		bundleId = args.bundleId
	gotoDoc(args.type, args.osVersion, args.device, bundleId)

if __name__ == '__main__':
  	main()