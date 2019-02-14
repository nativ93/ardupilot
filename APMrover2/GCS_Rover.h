#pragma once

#include <GCS_MAVLink/GCS.h>
#include "GCS_Mavlink.h"

class GCS_Rover : public GCS
{
    friend class Rover; // for access to _chan in parameter declarations

public:

    // return the number of valid GCS objects
    uint8_t num_gcs() const override { return ARRAY_SIZE(_chan); };

    // return GCS link at offset ofs
    GCS_MAVLINK_Rover &chan(const uint8_t ofs) override { return _chan[ofs]; };
    // return GCS link at offset ofs
    const GCS_MAVLINK_Rover &chan(const uint8_t ofs) const override { return _chan[ofs]; };

    void get_sensor_status_flags(uint32_t &present, uint32_t &enabled, uint32_t &health);

private:

    GCS_MAVLINK_Rover _chan[MAVLINK_COMM_NUM_BUFFERS];

};
