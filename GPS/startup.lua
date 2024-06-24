function update_and_load_database()
    if settings.get("gps_database") then
        settings.load("gps_database")
    else
        GPS_LN={x=121,y=123,z=-3}
        GPS_UN={x=GPS_LN.x, y=GPS_LN.y+3, z=GPS_LN.z}

        GPS_LS={x=GPS_LN.x, y=GPS_LN.y, z=GPS_LN.z+6}
        GPS_US={x=GPS_LS.x, y=GPS_LS.y+3, z=GPS_LS.z}
    
        GPS_LE={x=GPS_LN.x+3, y=GPS_LN.y, z=GPS_LN.z+3}
        GPS_UE={x=GPS_LE.x, y=GPS_LE.y+3, z=GPS_LE.z}

        GPS_LW={x=GPS_LN.x-3, y=GPS_LN.y, z=GPS_LN.z+3}
        GPS_UW={x=GPS_LW.x, y=GPS_LW.y+3, z=GPS_LW.z}

        settings.set("gps_database",
        {
            GPS_LN=GPS_LN,
            GPS_UN=GPS_UN,
            GPS_LS=GPS_LS,
            GPS_US=GPS_US,
            GPS_LE=GPS_LE,
            GPS_UE=GPS_UE,
            GPS_LW=GPS_LW,
            GPS_UW=GPS_UW
        })

        settings.save()
        settings.load("gps_database")
    end
end

function main()
    update_and_load_database()

    if(os.getComputerLabel() == nil) then 
        print("Computer has no label set yet!")
        return
    end
    coords = settings.get("gps_database")[os.getComputerLabel()]
    shell.run("gps", "host", coords.x, coords.y, coords.z)
end

main()