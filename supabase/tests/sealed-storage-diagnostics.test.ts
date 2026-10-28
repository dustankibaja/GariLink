import {test} from 'node:test';
import assert from 'node:assert/strict';
import {diagnoseSealedRead} from './sealed-storage-diagnostics.ts';

test('sealed diagnostic distinguishes metadata and backing read outcomes without leaking errors',async()=>{
  const calls:string[]=[];
  const result=await diagnoseSealedRead({expected:new Uint8Array([1]),
    metadata:async role=>{calls.push(`metadata:${role}`);if(role==='reader')throw new Error('private/path JWT secret');
      return {visible:true,versioned:true};},
    read:async role=>{calls.push(`read:${role}`);
      if(role==='sealer')throw new Error('STORAGE_READ_REJECTED stage=sealed-read status=500 code=InternalError');
      if(role==='reader')throw new Error('STORAGE_READ_REJECTED stage=sealed-read status=500 code=InternalError private/path');
      return new Uint8Array([1]);}});
  assert.deepEqual(result,{sealerMetadataVisible:true,sealerMetadataVersioned:true,readerMetadata:'REJECTED',
    sealerRead:'HTTP_500_InternalError',readerRead:'REJECTED',controlRead:'EXACT'});
  assert.deepEqual(calls,['metadata:sealer','metadata:reader','read:sealer','read:reader','read:control']);
});

test('sealed diagnostic reports missing metadata and digest mismatch without bytes or digest',async()=>{
  const result=await diagnoseSealedRead({expected:new Uint8Array([1]),
    metadata:async()=>({visible:false,versioned:false}),read:async()=>new Uint8Array([2])});
  assert.deepEqual(result,{sealerMetadataVisible:false,sealerMetadataVersioned:false,
    readerMetadataVisible:false,readerMetadataVersioned:false,sealerRead:'MISMATCH',readerRead:'MISMATCH',controlRead:'MISMATCH'});
});
