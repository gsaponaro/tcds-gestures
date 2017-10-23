/*
 * Copyright: (C) 2017 VisLab, Institute for Systems and Robotics,
 *                     Istituto Superior Técnico, Lisbon, Portugal
 * Author: Giovanni Saponaro
 * CopyPolicy: Released under the terms of the GNU GPL v2.0
 */

#ifndef HUMAN_HAND_PROCESSOR_MODULE_H
#define HUMAN_HAND_PROCESSOR_MODULE_H

#include <iostream>
#include <string>

#include <yarp/os/BufferedPort.h>
#include <yarp/os/Log.h>
#include <yarp/os/Network.h>
#include <yarp/os/RateThread.h>
#include <yarp/os/RFModule.h>

class HumanHandProcessorModule : public yarp::os::RFModule
{
private:

    yarp::os::BufferedPort<yarp::os::Bottle> inSkelPort;
    yarp::os::BufferedPort<yarp::os::Bottle> outHandPort;

public:

    bool configure(yarp::os::ResourceFinder &rf);
    bool interruptModule();
    bool close();

    double getPeriod();
    bool updateModule();
};

#endif // HUMAN_HAND_PROCESSOR_MODULE_H
