fs = require 'fs'
{exec} = require 'child_process'
should = require 'should'
Magician = require '../lib/magician'

describe 'Magician', ->
    it 'should resize image', (done) ->
        image = new Magician "#{ __dirname }/image.jpg", "#{ __dirname }/image_resized.jpg"
        image.resize width: 100, height: 100, (err) ->
            resizedImage = new Magician "#{ __dirname }/image_resized.jpg"
            resizedImage.getDimensions (err, dimensions) ->
                fs.unlinkSync "#{ __dirname }/image_resized.jpg"
                dimensions.width.should.equal(100) and dimensions.height.should.equal(100)
                do done
    
    it 'should crop image', (done) ->
        image = new Magician "#{ __dirname }/image.jpg", "#{ __dirname }/image_cropped.jpg"
        image.crop x: 0, y: 0, width: 200, height: 100, (err) ->
            croppedImage = new Magician "#{ __dirname }/image_cropped.jpg"
            croppedImage.getDimensions (err, dimensions) ->
                fs.unlinkSync "#{ __dirname }/image_cropped.jpg"
                dimensions.width.should.equal(200) and dimensions.height.should.equal(100)
                do done
    
    it 'should convert image', (done) ->
        image = new Magician "#{ __dirname }/image.jpg", "#{ __dirname }/image.png"
        image.convert ->
            fs.stat "#{ __dirname }/image.png", (err, stat) ->
                fs.unlinkSync "#{ __dirname }/image.png"
                should.exist(stat)
                do done
    
    it 'should get dimensions of an image', (done) ->
        image = new Magician "#{ __dirname }/image.jpg"
        image.getDimensions (err, dimensions) ->
            dimensions.width.should.equal(500) and dimensions.height.should.equal(250)
            do done
    
    it 'should write to folder with spaces in path', (done) ->
        fs.mkdirSync "#{ __dirname }/test folder"
        image = new Magician "#{ __dirname }/image.jpg", "#{ __dirname }/test folder/image.png"
        image.convert ->
            fs.stat "#{ __dirname }/test folder/image.png", (err, stat) ->
                exec "rm -rf #{ __dirname }/test\\ folder", ->
                should.exist(stat)
                do done