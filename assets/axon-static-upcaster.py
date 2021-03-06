#!/usr/bin/env python
# coding: utf-8
from pymongo import MongoClient
import semantic_version as SEMVER


################################################################################
# Required steps for installation/usage:
# 1.) sudo pip install semantic_version
################################################################################


################################################################################
# Static-Upcaster
#
# Iterates over the event store and selects all events that match the given
# 'event_type' and are below the given 'target_version'. The supplied
# 'upcast' function is allowed to change the event itself.
#
# Use the 'dry_run' and 'dry_run_max' parameters to try things out first
# Set 'event_type' to None in order to iterate over all events
################################################################################
class StaticUpcaster:
    _db = None
    _event_to_upcast = None
    _versions_to_upcast = None
    _upcast = None
    _dry_run = None
    _dry_run_max = None

    def __init__(self, db, event_type, target_version, upcast, dry_run = False, dry_run_max = -1):
        self._db = db
        self._event_to_upcast = event_type
        self._versions_to_upcast = SEMVER.Spec("<%s" % target_version)
        self._upcast = upcast
        self._dry_run = dry_run
        self._dry_run_max = dry_run_max

    def upcast(self):
        cursor = None
        if self._event_to_upcast:
            cursor = self._db.domainEvents.find({"events.payloadType": self._event_to_upcast})
        else:
            cursor = self._db.domainEvents.find()
        counter = 1
        for domain_event in cursor:
            if self._dry_run and counter > self._dry_run_max and self._dry_run_max > 0:
                break
            identity = domain_event["_id"]
            updated_events = []
            requires_update = False
            for event in domain_event["events"]:
                type = event["payloadType"]
                revision = event["payloadRevision"]
                version = None
                if revision is None:
                  version = SEMVER.Version("0.0.0", partial = True)
                else:
                  version = SEMVER.Version(revision, partial = True)
                if self._event_to_upcast is not None and self._event_to_upcast == type and self._versions_to_upcast.match(version):
                    upcasted_event = self._upcast(event)
                    updated_events.append(upcasted_event)
                    requires_update = True
                    counter += 1
                elif self._event_to_upcast is None and self._versions_to_upcast.match(version):
                    upcasted_event = self._upcast(event)
                    updated_events.append(upcasted_event)
                    requires_update = True
                    counter += 1
                else:
                    updated_events.append(event)
            if requires_update and not self._dry_run:
                self._db.domainEvents.update({"_id": identity}, {"$set": {"events": updated_events}})
################################################################################


################################################################################
# UPCASTER SETTINGS
#
# Change the following lines while keeping the rest as it is
################################################################################
# The event type to upcast; Validate against the 'payloadType' property of your
# domain events.
event_to_upcast = "fully.qualified.class.name"
# The target version to set. All events below that version will be upcasted and
# will receive this new version number.
target_version = "1.2.3"

# The function used for upcasting - change accordingly
def upcasting_function(event):
    # change event here
    return event

# create upcaster instance
upcaster = StaticUpcaster(
    db = MongoClient().my_mongo_database
    ,event_type = None
    ,target_version = target_version
    ,upcast = upcasting_function
    ,dry_run = True
    ,dry_run_max = 5
    )
################################################################################


################################################################################
# upcast all matching events permanently, or use 'dry_run = True'
upcaster.upcast()
