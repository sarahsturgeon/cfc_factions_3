-- This file handles net responses but also type checking on those responses
import insert from table

cfcFactions.net or= {}
cNet = cfcFactions.net

logger = cfcFactions.logger

checkColorComponent = ( str ) ->
    num = tonumber str
    return false if not num
    return false if num % 1 ~= 0

    return ( num >= 0 ) and ( num <= 255 )

local customTypeCheckers
customTypeCheckers =
    color: ( data, val ) ->
        valid = IsColor val
        return false, "Expected Color, got #{type val}" if not valid

        return false, "Non-255 alpha not allowed" if ( not data.hasAlpha ) and val.a ~= 255

        return true
    colorstring: ( data, val ) ->
        return false, "Expected ColorString, got #{type val}" if ( type val ) ~= "string"

        splitStr = string.Explode ",", val
        return false, "Wrong number of values" if ( #splitStr < 3 ) or ( #splitStr > 4 )

        r = checkColorComponent splitStr[1]
        g = checkColorComponent splitStr[2]
        b = checkColorComponent splitStr[3]
        a = checkColorComponent splitStr[4]

        return false, "Invalid number in color" if not ( r and g and b )
        return false, "Invalid number in color" if splitStr[4] and not a

        return false, "Non-255 alpha not allowed" if ( not data.hasAlpha ) and a and ( splitStr[4] ~= "255" )

        return true
    string: ( data, val ) ->
        return false, "Expected string, got #{type val}" if ( type val ) ~= "string"

        if data.minLength
            return false, "Must be >=#{data.minLength} characters" if #val < data.minLength

        if data.maxLength
            return false, "Must be <=#{data.maxLength} characters" if #val > data.maxLength

        return true
    decimal: ( data, val ) ->
        return false, "Expected number, got #{type val}" if ( type val ) ~= "number"

        if data.min
            return false, "Must be >=#{data.min}" if val < data.min

        if data.max
            return false, "Must be <=#{data.max}" if val > data.max

        return true
    integer: ( data, val ) ->
        return false, "Expected number, got #{type val}" if ( type val ) ~= "number"

        return false, "Expected integer, got decimal" if val % 1 ~= 0

        return customTypeCheckers.decimal data, val

checkType = ( got, expected ) ->
    return false, "No expected value?" if expected == nil

    gotType = (type got)\lower!
    expectedType = expected.type\lower!

    if customTypeCheckers[expectedType]
        return customTypeCheckers[expectedType] expected, got

    return false, "Expected #{expectedType}, got #{gotType}" if gotType ~= expectedType
    true

validateTypes = ( types ) ->
    for k, argType in pairs types
        if ( type argType ) == "string"
            types[k] =
                type: argType
                name: tostring k
        if ( argType.type\lower! == "colorstring" ) or ( argType.type\lower! == "color" )
            argType.hasAlpha = true if argType.hasAlpha == nil

findPermissionTarget = ( types ) ->
    for k, argType in pairs types
        return k if ( argType.type\lower! == "player" ) and ( argType.isPermissionTarget )

cNet.RegisterResponse = ( name, types, permissions, callback ) ->
    validateTypes types
    netName = "cfc_Fac_#{name}"
    targetIndex = findPermissionTarget types
    NP.net.receive netName, async ( ply, ... ) ->
        data = { ... }
        reject { argumentError: "Invalid number of arguments, expected #{#types}, got #{#data}" } if #types ~= #data

        errors = {}
        for k, value in pairs data
            valid, err = checkType value, types[k]
            unless valid
                errors[types[k].name] = err

        reject { argumentError: errors } unless table.IsEmpty errors

        local permissionTarget
        if targetIndex
            permissionTarget = data[targetIndex]

        await ( cfcFactions.permissions.assertMany ply, permissions, permissionTarget ), AwaitTypes.PROPAGATE

        ret = { xdcall callback, ply, unpack data }

        success = table.remove ret, 1

        unless success
            logger\fatal ret[1]
            reject { internalError: "Something went wrong" }

        if isPromise ret[1]
            ret = { await ret[1] }
            success = table.remove ret, 1

        unless success
            if ( type ret[1] ) == "string"
                logger\fatal ret[1]
                reject { internalError: "Something went wrong" }
            reject unpack ret

        return unpack ret

cNet.RegisterResponse "test", {
    {
        type: "string"
        name: "first"
        minLength: 5
        maxLength: 30
    },
    {
        type: "boolean"
        name: "hoolean"
    },
    {
        type: "colorstring"
        name: "urmom"
    },
    {
        type: "colorstring"
        name: "urmombutopaque"
        hasAlpha: false
    },
    {
        type: "integer"
        name: "int"
        min: 3
        max: 5
    }
}, {}, print