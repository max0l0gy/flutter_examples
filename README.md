@PostMapping(path ="/eshop" , consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
FileUploadResponse uploadFile(@RequestParam("key") String key,
                              @RequestPart("file") MultipartFile file);

