import {createHash} from 'node:crypto';

/** Disposable-runner diagnostics only. Never forward exception text or identifiers. */
export async function diagnoseSealedRead(input:{
  expected:Uint8Array;
  metadata:(role:'sealer'|'reader')=>Promise<{visible:boolean;versioned:boolean}>;
  read:(role:'sealer'|'reader'|'control')=>Promise<Uint8Array>;
}) {
  const results:Record<string,string|boolean>={};
  for(const role of ['sealer','reader'] as const){
    try{
      const value=await input.metadata(role);
      results[`${role}MetadataVisible`]=value.visible===true;
      results[`${role}MetadataVersioned`]=value.versioned===true;
    }catch{results[`${role}Metadata`]='REJECTED';}
  }
  const digest=(bytes:Uint8Array)=>createHash('sha256').update(bytes).digest('hex');
  for(const role of ['sealer','reader','control'] as const){
    try{results[`${role}Read`]=digest(await input.read(role))===digest(input.expected)?'EXACT':'MISMATCH';}
    catch(error){
      // Match the entire trusted adapter format; no arbitrary provider text.
      const match=error instanceof Error && /^STORAGE_READ_REJECTED stage=sealed-read status=([1-5][0-9]{2}) code=(NoSuchKey|NoSuchBucket|AccessDenied|Unauthorized|InvalidJWT|InvalidSignature|SignatureDoesNotMatch|InvalidKey|StorageBackendError|DatabaseError|42501|InternalError|UnknownError|UNSPECIFIED)$/.exec(error.message);
      results[`${role}Read`]=match?`HTTP_${match[1]}_${match[2]}`:'REJECTED';
    }
  }
  return results;
}
